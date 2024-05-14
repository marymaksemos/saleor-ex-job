"use server";
import invariant from "ts-invariant";
import { revalidatePath } from "next/cache";
import { CheckoutAddLineDocument } from "@/gql/graphql";
import * as Checkout from "@/lib/checkout";
import { executeGraphQL } from "@/lib/graphql";

export async function addItem({ channel, variant }: { channel: string; variant?: string }) {
	const checkout = await Checkout.findOrCreate({
		channel,
		checkoutId: Checkout.getIdFromCookies(channel),
	});

	invariant(checkout, "This should never happen");

	Checkout.saveIdToCookie(channel, checkout.id);

	if (variant)
		await executeGraphQL(CheckoutAddLineDocument, {
			variables: {
				id: checkout.id,
				productVariantId: decodeURIComponent(variant),
			},
			cache: "no-cache",
		});

	revalidatePath("/cart");
}
