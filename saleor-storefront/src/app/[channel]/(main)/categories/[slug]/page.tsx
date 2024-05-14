import { notFound } from "next/navigation";
import { type ResolvingMetadata, type Metadata } from "next";
import { ProductListByCategoryDocument } from "@/gql/graphql";
import { executeGraphQL } from "@/lib/graphql";
import { SideNavbar } from "@/ui/components/SideNavbar/SideNavbar";
import { ProductElement } from "@/ui/components/ProductElement";

export const generateMetadata = async (
	{ params }: { params: { slug: string; channel: string } },
	parent: ResolvingMetadata,
): Promise<Metadata> => {
	const { category } = await executeGraphQL(ProductListByCategoryDocument, {
		variables: { slug: params.slug, channel: params.channel },
		revalidate: 60,
	});

	return {
		title: `${category?.name || "Categroy"} | ${category?.seoTitle || (await parent).title?.absolute}`,
		description: category?.seoDescription || category?.description || category?.seoTitle || category?.name,
	};
};

export default async function Page({ params }: { params: { slug: string; channel: string } }) {
	const { category } = await executeGraphQL(ProductListByCategoryDocument, {
		variables: { slug: params.slug, channel: params.channel },
		revalidate: 60,
	});

	if (!category || !category.products) {
		notFound();
	}

	const { name, products } = category;

	return (
		<div className="mx-auto max-w-screen-2xl space-y-8 pt-8">
			<div className="mx-4 rounded-lg border bg-white p-8 shadow-sm">
				<h1 className="font-semibold text-gray-800">{name} Category</h1>
			</div>
			<div className="flex items-start justify-start">
				<div className="sticky top-16 hidden min-w-[300px] p-4 lg:block">
					<SideNavbar
						className="font-sm col-span-2 rounded-lg border bg-white p-4 shadow-md"
						channel={params.channel}
					/>
				</div>
				<div className="w-[100% - 300px] min-h-[70vh] overflow-hidden p-4">
					<div className="grid w-full grid-cols-2 gap-4 md:grid-cols-3 lg:grid-cols-3">
						{products.edges.map(({ node: product }, index) => (
							<ProductElement
								key={product.id}
								product={product}
								priority={index < 4}
								loading={index < 8 ? "eager" : "lazy"}
							/>
						))}
					</div>
				</div>
			</div>
		</div>
	);
}
